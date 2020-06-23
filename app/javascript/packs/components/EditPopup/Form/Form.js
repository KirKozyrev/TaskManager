import React from 'react';
import PropTypes from 'prop-types';
import { has } from 'ramda';
import TextField from '@material-ui/core/TextField';
import Input from '@material-ui/core/Input';

import UserSelect from 'components/UserSelect';
import TaskPresenter from 'presenters/TaskPresenter';

import useStyles from './useStyles';

const Form = ({ errors, onChange, task }) => {
  const fileInput = React.createRef();
  const handleChangeTextField = (fieldName) => (event) => onChange({ ...task, [fieldName]: event.target.value });
  const handleChangeSelect = (fieldName) => (user) => onChange({ ...task, [fieldName]: user });
  const styles = useStyles();

  const handleChangeFileInput = (fieldName) => () => {
    const reader = new FileReader();
    const fileInfo = fileInput.current.files[0];
    reader.readAsDataURL(fileInfo);

    reader.onloadend = () => {
      const file = { dataUrl: reader.result, name: fileInfo.name, type: fileInfo.type };
      onChange({ ...task, [fieldName]: file });
    };
  };

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
      <Input
        className={styles.fileInput}
        onChange={handleChangeFileInput('file')}
        error={has('file', errors)}
        type="file"
        inputRef={fileInput}
        margin="dense"
      />
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
