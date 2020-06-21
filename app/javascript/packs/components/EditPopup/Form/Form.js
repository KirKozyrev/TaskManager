import React from 'react';
import PropTypes from 'prop-types';
import { has } from 'ramda';
import TextField from '@material-ui/core/TextField';
import Input from '@material-ui/core/Input';
import Button from '@material-ui/core/Button';

import UserSelect from 'components/UserSelect';
import TaskPresenter from 'presenters/TaskPresenter';

import useStyles from './useStyles';

const Form = ({ errors, onChange, task }) => {
  const fileInput = React.createRef();
  const handleChangeTextField = (fieldName) => (event) => onChange({ ...task, [fieldName]: event.target.value });
  const handleButtonClick = (fieldName) => () => onChange({ ...task, [fieldName]: fileInput.current.files[0].name });
  const handleChangeSelect = (fieldName) => (user) => onChange({ ...task, [fieldName]: user });
  const styles = useStyles();

  return (
    <form className={styles.root}>
      <TextField
        error={has('name', errors)}
        helperText={errors.name}
        onChange={handleChangeTextField('name')}
        value={TaskPresenter.name(task)}
        label="Name"
        required
        margin="dense"
      />
      <TextField
        error={has('description', errors)}
        helperText={errors.description}
        onChange={handleChangeTextField('description')}
        value={TaskPresenter.description(task)}
        label="Description"
        required
        multiline
        margin="dense"
      />
      <UserSelect
        label="Author"
        value={TaskPresenter.author(task)}
        onChange={handleChangeSelect('author')}
        error={has('author', errors)}
        helperText={errors.author}
      />
      <UserSelect
        label="Assignee"
        value={TaskPresenter.assignee(task)}
        onChange={handleChangeSelect('assignee')}
        isRequired={false}
        error={has('assignee', errors)}
        helperText={errors.assignee}
      />
      <Input className={styles.fileInput} error={has('file', errors)} type="file" inputRef={fileInput} margin="dense" />
      <Button onClick={handleButtonClick('file')} size="small" variant="contained" color="primary" margin="dense">
        Submit file
      </Button>
    </form>
  );
};

Form.propTypes = {
  onChange: PropTypes.func.isRequired,
  task: PropTypes.shape().isRequired,
  errors: PropTypes.shape({
    name: PropTypes.arrayOf(PropTypes.string),
    description: PropTypes.arrayOf(PropTypes.string),
    author: PropTypes.arrayOf(PropTypes.string),
    assignee: PropTypes.arrayOf(PropTypes.string),
    file: PropTypes.arrayOf(PropTypes.string),
  }),
};

Form.defaultProps = {
  errors: {},
};

export default Form;
