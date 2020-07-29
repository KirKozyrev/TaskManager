require('@rails/ujs').start();
require('@rails/activestorage').start();
require('channels');

import 'stylesheets/application';
import 'material-design-lite/material.js';
import WebpackerReact from 'webpacker-react';
import App from 'javascript/App.js';

WebpackerReact.setup({ App });
