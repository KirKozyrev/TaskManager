import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(() => ({
  root: {
    display: 'flex',
    flexDirection: 'column',
  },
  previewContainer: {
    width: '80%',
    margin: '15px auto 0',
  },
  preview: {
    width: '100%',
    marginBottom: 10,
    display: 'block',
  },
}));

export default useStyles;
