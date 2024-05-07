import { makeScene2D } from '@motion-canvas/2d';
import { createShaderView } from '../util';
import shader from '../shaders/shader004.glsl';

const duration = 2 / 0.3;
export default makeScene2D(createShaderView(shader, duration));
