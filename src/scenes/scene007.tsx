import { makeScene2D } from '@motion-canvas/2d';
import { createShaderView } from '../util';
import shader from '../shaders/shader007.glsl';

export default makeScene2D(createShaderView(shader, 10.0));
