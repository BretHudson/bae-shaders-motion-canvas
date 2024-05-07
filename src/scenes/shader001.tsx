import { Rect, makeScene2D } from '@motion-canvas/2d';
import { waitFor } from '@motion-canvas/core';
import shader from '../shaders/shader001.glsl';

export default makeScene2D(function* (view) {
	view.add(<Rect width={960} height={540} fill={'magenta'} shaders={shader} />);

	yield* waitFor(3.0);
});
