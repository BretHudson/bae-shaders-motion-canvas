import { makeProject } from '@motion-canvas/core';

import scene001 from './scenes/scene001?scene';
import scene002 from './scenes/scene002?scene';
import scene003 from './scenes/scene003?scene';
import scene004 from './scenes/scene004?scene';
import scene005 from './scenes/scene005?scene';
import scene006 from './scenes/scene006?scene';
import scene007 from './scenes/scene007?scene';
import scene008 from './scenes/scene008?scene';
import scene009 from './scenes/scene009?scene';

export default makeProject({
	scenes: [
		// scene001,
		// scene002,
		// scene003,
		// scene004,
		// scene005,
		// scene006,
		// scene007,
		// scene008,
		scene009,
	],
	name: 'shaders',
	experimentalFeatures: true,
});
