import { propEq } from 'ramda';
import { createSlice } from '@reduxjs/toolkit';
import TasksRepository from 'repositories/TasksRepository';
import { useDispatch } from 'react-redux';
import { changeColumn } from '@lourenci/react-kanban';

const STATES = [
  { key: 'new_task', value: 'New' },
  { key: 'in_development', value: 'In Dev' },
  { key: 'in_qa', value: 'In QA' },
  { key: 'in_code_review', value: 'in CR' },
  { key: 'ready_for_release', value: 'Ready for release' },
  { key: 'released', value: 'Released' },
  { key: 'archived', value: 'Archived' },
];

const initialState = {
  board: {
    columns: STATES.map((column) => ({
      id: column.key,
      title: column.value,
      cards: [],
      meta: {},
    })),
  },
};

const getColumnIndex = (state, key) => {
  const column = state.board.columns.find(propEq('id', key));
  return state.board.columns.indexOf(column);
};

const getCardIndex = (state, columnIndex, id) => {
  const card = state.board.columns[columnIndex].cards.find(propEq('id', id));
  return state.board.columns[columnIndex].cards.indexOf(card);
};

const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    loadColumnSuccess(state, { payload }) {
      const { items, meta, columnId } = payload;
      const column = state.board.columns.find(propEq('id', columnId));
      state.board = changeColumn(state.board, column, {
        cards: items,
        meta,
      });

      return state;
    },

    loadColumnMoreSuccess(state, { payload }) {
      const { items, meta, columnId } = payload;
      const column = state.board.columns.find(propEq('id', columnId));
      const indexOfColumn = getColumnIndex(state, columnId);
      const cards = state.board.columns[indexOfColumn].cards.concat(items);
      state.board = changeColumn(state.board, column, {
        cards,
        meta,
      });

      return state;
    },

    createTaskSuccess(state, { payload }) {
      const { task } = payload;
      const indexOfColumn = getColumnIndex(state, task.state);

      state.board.columns[indexOfColumn].cards.unshift(task);
      return state;
    },

    updateTaskSuccess(state, { payload }) {
      const { task } = payload;
      const indexOfColumn = getColumnIndex(state, task.state);
      const indexOfCard = getCardIndex(state, indexOfColumn, task.id);

      state.board.columns[indexOfColumn].cards[indexOfCard] = task;
      return state;
    },

    destroyTaskSuccess(state, { payload }) {
      const { task } = payload;
      const indexOfColumn = getColumnIndex(state, task.state);
      const indexOfCard = getCardIndex(state, indexOfColumn, task.id);

      state.board.columns[indexOfColumn].cards.splice(indexOfCard, 1);
      return state;
    },

    moveTaskSuccess(state, { payload }) {
      const { task: oldTask, responseData: newTask } = payload;
      const indexOfColumnOldTask = getColumnIndex(state, oldTask.state);
      const indexOfCard = getCardIndex(state, indexOfColumnOldTask, oldTask.id);

      state.board.columns[indexOfColumnOldTask].cards.splice(indexOfCard, 1);

      const indexOfColumnNewTask = getColumnIndex(state, newTask.state);

      state.board.columns[indexOfColumnNewTask].cards.unshift(newTask);
      return state;
    },
  },
});

const {
  loadColumnSuccess,
  loadColumnMoreSuccess,
  createTaskSuccess,
  updateTaskSuccess,
  destroyTaskSuccess,
  moveTaskSuccess,
} = tasksSlice.actions;

export default tasksSlice.reducer;

export const useTasksActions = () => {
  const dispatch = useDispatch();

  const loadTask = (taskId) => {
    return TasksRepository.show(taskId).then(({ data: { task } }) => task);
  };

  const loadColumn = (state, page = 1, perPage = 10) => {
    TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    }).then(({ data }) => {
      dispatch(loadColumnSuccess({ ...data, columnId: state }));
    });
  };

  const loadMoreCards = (state, page = 1, perPage = 10) => {
    TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    }).then(({ data }) => {
      dispatch(loadColumnMoreSuccess({ ...data, columnId: state }));
    });
  };

  const createTask = (params) => {
    return TasksRepository.create(params).then(({ data }) => {
      dispatch(createTaskSuccess(data));
    });
  };

  const updateTask = (taskId, attributes) => {
    return TasksRepository.update(taskId, attributes).then(({ data }) => {
      dispatch(updateTaskSuccess(data));
    });
  };

  const destroyTask = (task) => {
    return TasksRepository.destroy(task.id).then(() => {
      dispatch(destroyTaskSuccess({ task }));
    });
  };

  const moveTask = (task, attributes) => {
    return TasksRepository.update(task.id, attributes).then(({ data }) => {
      const responseData = data.task;
      dispatch(moveTaskSuccess({ task, responseData }));
    });
  };

  const attachImage = (taskId, attachment) => {
    return TasksRepository.attachImage(taskId, attachment).then(({ data }) => {
      dispatch(updateTaskSuccess(data));
    });
  };

  const removeImage = (taskId) => {
    return TasksRepository.removeImage(taskId).then(({ data }) => {
      dispatch(updateTaskSuccess(data));
    });
  };

  const loadBoard = () => STATES.map(({ key }) => loadColumn(key));

  return {
    loadTask,
    loadBoard,
    createTask,
    destroyTask,
    updateTask,
    moveTask,
    loadMoreCards,
    attachImage,
    removeImage,
  };
};
