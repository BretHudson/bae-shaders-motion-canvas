import { Rect, View2D } from '@motion-canvas/2d';
import { waitFor } from '@motion-canvas/core';
import { PossibleShaderConfig } from '@motion-canvas/2d/lib/partials/ShaderConfig';

export const createShaderView = (
	shader: PossibleShaderConfig,
	duration: number,
) => {
	return function* (view: View2D) {
		view.add(
			<Rect width={960} height={540} fill={'magenta'} shaders={shader} />,
		);

		yield* waitFor(duration);
	};
};
