import { pick, propOr } from 'ramda';

export default {
  defaultAttributes(attributes) {
    return {
      name: '',
      description: '',
      ...attributes,
    };
  },

  attributesToSubmit(task) {
    const pertmittedKeys = ['id', 'name', 'description', 'assigneeId', 'authorId', 'file'];

    const authorIdOrDefault = propOr(task.author, 'id');
    const assigneeIdOrDefault = propOr(task.assignee, 'id');

    return {
      ...pick(pertmittedKeys, task),
      assigneeId: assigneeIdOrDefault(task.assignee),
      authorId: authorIdOrDefault(task.author),
    };
  },
};
