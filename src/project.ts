import { makeProject } from '@motion-canvas/core';

import shader001 from './scenes/shader001?scene';
import shader002 from './scenes/shader002?scene';

export default makeProject({
	scenes: [shader001, shader002],
	name: 'shaders',
	experimentalFeatures: true,
});
