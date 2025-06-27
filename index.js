/**
 * DeadTime Mobile App
 * Entry point for React Native application
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

// Register the main component
AppRegistry.registerComponent(appName, () => App);
