import { useSelector } from 'react-redux';
import { useTasksActions } from 'slices/TasksSlice';
import TasksRepository from 'repositories/TasksRepository';

const TaskBoardContainer = (props) => {
  const { children } = props;
  const board = useSelector((state) => state.TasksSlice.board);

  const loadTask = (taskId) => {
    return TasksRepository.show(taskId).then(({ data: { task } }) => task);
  };

  const { loadBoard, createTask } = useTasksActions();

  return children({
    board,
    loadBoard,
    createTask,
    loadTask,
  });
};

export default TaskBoardContainer;
