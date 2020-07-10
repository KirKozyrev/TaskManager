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
      const indexOfColumn = state.board.columns.indexOf(column);
      const cards = state.board.columns[indexOfColumn].cards.concat(items);
      state.board = changeColumn(state.board, column, {
        cards,
        meta,
      });

      return state;
    },

    createTaskSuccess(state, { payload }) {
      const { task } = payload;
      const column = state.board.columns.find(propEq('id', task.state));
      const indexOfColumn = state.board.columns.indexOf(column);

      state.board.columns[indexOfColumn].cards.unshift(task);
      return state;
    },

    updateTaskSuccess(state, { payload }) {
      const { task } = payload;
      const column = state.board.columns.find(propEq('id', task.state));
      const indexOfColumn = state.board.columns.indexOf(column);
      const card = state.board.columns[indexOfColumn].cards.find(propEq('id', task.id));
      const indexOfCard = state.board.columns[indexOfColumn].cards.indexOf(card);

      state.board.columns[indexOfColumn].cards[indexOfCard] = task;
      return state;
    },

    destroyTaskSuccess(state, { payload }) {
      const { task } = payload;
      const column = state.board.columns.find(propEq('id', task.state));
      const indexOfColumn = state.board.columns.indexOf(column);
      const card = state.board.columns[indexOfColumn].cards.find(propEq('id', task.id));
      const indexOfCard = state.board.columns[indexOfColumn].cards.indexOf(card);

      state.board.columns[indexOfColumn].cards.splice(indexOfCard, 1);
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
} = tasksSlice.actions;

export default tasksSlice.reducer;

export const useTasksActions = () => {
  const dispatch = useDispatch();

  const loadColumn = (state, page = 1, perPage = 10) => {
    TasksRepository.index({
      q: { stateEq: state },
      page,
      perPage,
    }).then(({ data }) => {
      dispatch(loadColumnSuccess({ ...data, columnId: state }));
    });
  };

  const loadMoreCards = (state, page, perPage = 10) => {
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

  const changeState = (task, attributes) => {
    return TasksRepository.update(task.id, attributes).then(({ data }) => {
      dispatch(destroyTaskSuccess({ task }));
      dispatch(createTaskSuccess(data));
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
    loadBoard,
    createTask,
    destroyTask,
    updateTask,
    changeState,
    loadMoreCards,
    attachImage,
    removeImage,
  };
};
