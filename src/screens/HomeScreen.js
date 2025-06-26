import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

const HomeScreen = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>🎯 DeadTime</Text>
      <Text style={styles.subtitle}>AI is detecting opportunities...</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F8F9FA',
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#2C3E50',
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 16,
    color: '#7F8C8D',
  },
});

export default HomeScreen;
