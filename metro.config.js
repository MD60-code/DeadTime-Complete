const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');

const config = {
  transformer: {
    assetPlugins: ['react-native-svg-transformer'],
  },
  resolver: {
    assetExts: ['bin', 'txt', 'jpg', 'png', 'json', 'mp4', 'mov'],
    sourceExts: ['js', 'jsx', 'ts', 'tsx', 'json', 'svg'],
  },
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);