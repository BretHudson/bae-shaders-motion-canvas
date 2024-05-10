import { Rect, View2D } from '@motion-canvas/2d';
import { waitFor } from '@motion-canvas/core';

export const createShaderView = (shader: string, duration: number) => {
	return function* (view: View2D) {
		view.add(
			<Rect
				width={1080}
				height={1920}
				fill={'magenta'}
				shaders={{
					fragment: shader,
					uniforms: {
						iTime: view.globalTime(),
					},
				}}
			/>,
		);

		yield* waitFor(duration);
	};
};
