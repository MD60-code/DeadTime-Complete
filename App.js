/**
 * DeadTime Mobile App
 * Main App Component
 */

import React from 'react';
import {StatusBar} from 'react-native';
import AppNavigator from './src/AppNavigator';

const App = () => {
  return (
    <>
      <StatusBar 
        barStyle="dark-content" 
        backgroundColor="#ffffff" 
        translucent={false}
      />
      <AppNavigator />
    </>
  );
};

export default App;
