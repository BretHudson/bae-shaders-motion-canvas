import { makeProject } from '@motion-canvas/core';

import shader001 from './scenes/shader001?scene';

export default makeProject({
	scenes: [shader001],
	experimentalFeatures: true,
});
