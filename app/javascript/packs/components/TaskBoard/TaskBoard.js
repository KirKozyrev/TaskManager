import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import KanbanBoard from '@lourenci/react-kanban';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import { useTasksActions } from 'slices/TasksSlice';

import Task from 'components/Task';
import TaskForm from 'forms/TaskForm';
import AddPopup from 'components/AddPopup';
import EditPopup from 'components/EditPopup';
import ColumnHeader from 'components/ColumnHeader';
import AttachmentForm from 'forms/AttachmentForm';

import useStyles from './useStyles';

const MODES = {
  ADD: 'add',
  EDIT: 'edit',
  NONE: 'none',
};

const TaskBoard = (props) => {
  const styles = useStyles();
  const {
    loadTask,
    createTask,
    destroyTask,
    updateTask,
    moveTask,
    loadMoreCards,
    attachImage,
    removeImage,
  } = useTasksActions();

  const { board, loadBoard } = props;
  const [mode, setMode] = useState(MODES.NONE);
  const [openedTaskId, setOpenedTaskId] = useState(null);

  useEffect(() => {
    loadBoard();
  }, []);

  const handleOpenAddPopup = () => {
    setMode(MODES.ADD);
  };

  const handleOpenEditPopup = (task) => {
    setOpenedTaskId(task.id);
    setMode(MODES.EDIT);
  };

  const handleClose = () => {
    setMode(MODES.NONE);
  };

  const loadColumnMore = (state, page) => {
    loadMoreCards(state, page);
  };

  const handleTaskCreate = (params) => {
    const attributes = TaskForm.attributesToSubmit(params);

    return createTask(attributes).then(() => {
      handleClose();
    });
  };

  const handleTaskLoad = (id) => {
    return loadTask(id);
  };

  const handleTaskUpdate = (task) => {
    const attributes = TaskForm.attributesToSubmit(task);

    return updateTask(task.id, attributes).then(() => {
      handleClose();
    });
  };

  const handleTaskDestroy = (task) => {
    return destroyTask(task).then(() => {
      handleClose();
    });
  };

  const handleCardDragEnd = (task, source, destination) => {
    const transition = task.transitions.find(({ to }) => destination.toColumnId === to);
    if (!transition) {
      return null;
    }

    return moveTask(task, { task: { stateEvent: transition.event } })
      .then(() => {})
      .catch((error) => {
        alert(`Move failed! ${error.message}`);
      });
  };

  const handleAttachImage = (task, attachment) => {
    const attributes = AttachmentForm.attributesToSubmit(attachment);

    return attachImage(task.id, { attachment: attributes }).then(() => {
      handleClose();
    });
  };

  const handleRemoveImage = (task) => {
    return removeImage(task.id).then(() => {
      handleClose();
    });
  };

  return (
    <>
      <KanbanBoard
        onCardDragEnd={handleCardDragEnd}
        renderCard={(card) => <Task onClick={handleOpenEditPopup} task={card} />}
        renderColumnHeader={(column) => <ColumnHeader column={column} onLoadMore={loadColumnMore} />}
      >
        {board}
      </KanbanBoard>
      {mode === MODES.ADD && <AddPopup onCreateCard={handleTaskCreate} onClose={handleClose} />}
      {mode === MODES.EDIT && (
        <EditPopup
          onLoadCard={handleTaskLoad}
          onDestroyCard={handleTaskDestroy}
          onUpdateCard={handleTaskUpdate}
          onAttachImage={handleAttachImage}
          onRemoveImage={handleRemoveImage}
          onClose={handleClose}
          cardId={openedTaskId}
        />
      )}
      <Fab className={styles.addButton} onClick={handleOpenAddPopup} color="primary" aria-label="add">
        <AddIcon />
      </Fab>
    </>
  );
};

TaskBoard.propTypes = {
  loadBoard: PropTypes.func.isRequired,
  board: PropTypes.shape({
    columns: PropTypes.arrayOf(
      PropTypes.shape({
        id: PropTypes.string.isRequired,
        title: PropTypes.string.isRequired,
        cards: PropTypes.array.isRequired,
        meta: PropTypes.shape({}).isRequired,
      }),
    ),
  }).isRequired,
};

export default TaskBoard;
