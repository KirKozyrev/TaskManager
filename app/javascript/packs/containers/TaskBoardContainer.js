import { useSelector } from 'react-redux';
import { useTasksActions } from 'slices/TasksSlice';

const TaskBoardContainer = (props) => {
  const { children } = props;
  const board = useSelector((state) => state.TasksSlice.board);

  const { loadBoard, createTask } = useTasksActions();

  return children({
    board,
    loadBoard,
    createTask,
  });
};

export default TaskBoardContainer;
