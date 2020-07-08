import { pick } from 'ramda';

export default {
  attributesToSubmit(attachment) {
    const pertmittedKeys = ['cropX', 'cropY', 'cropWidth', 'cropHeight', 'image'];

    return {
      ...pick(pertmittedKeys, attachment),
    };
  },
};
