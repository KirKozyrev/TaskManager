import routes from 'routes';
import FetchHelper from '../../utils/fetchHelper';

export default {
  index(params) {
    const path = routes.apiV1TasksPath();
    return FetchHelper.get(path, params);
  },

  show(id) {
    const path = routes.apiV1TaskPath(id);
    return FetchHelper.get(path);
  },

  update(id, params) {
    const path = routes.apiV1TaskPath(id);
    return FetchHelper.put(path, params);
  },

  create(params) {
    const path = routes.apiV1TasksPath();
    return FetchHelper.post(path, params);
  },

  destroy(id) {
    const path = routes.apiV1TaskPath(id);
    return FetchHelper.delete(path);
  },

  attachImage(id, params) {
    const path = routes.apiV1TaskPath(id);
    return FetchHelper.putFormData(path, params);
  },
};
