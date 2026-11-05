import { Game, planRally } from './sim.js';
for (const seat of [0, 1]) for (const lat of [1, 0.5, 0, -0.5, -1]) {
  const sg = seat === 0 ? 1 : -1, o = 1 - seat;
  const g = new Game(); g.seats[seat].kind = 'human'; g.seats[seat].name = 'T'; g.startMatch({ skill: 0.6 });
  g.phase = 'rally'; g.ballStage = 'oppBounce'; g.lastHitter = o; g.server = o;
  g.ball.p = [0, 6, -sg * 15]; g.ball.v = [0, 0, 0]; planRally(g.ball, 0, 12, 0.6, 0, -sg);
  let bx = null;
  for (let f = 0; f < 400 && g.phase === 'rally'; f++) {
    const s = g.seats[seat]; s.tilt = { y: [0, 1, 0.15], z: [0, -0.15, 1] }; s.tiltT = g.t;
    if (g.ballStage === 'live' && g.t - s.swingT > 0.3 && g.ball.p[2] * sg > 0 && !s.swing?.t) g.registerSwing(seat, { power: 0.7, side: lat > 0 ? -1 : 1, spin: 0, aim: 0, lat });
    else if (g.ballStage === 'live' && g.t - s.swingT > 0.5) g.registerSwing(seat, { power: 0.7, side: lat > 0 ? -1 : 1, spin: 0, aim: 0, lat });
    const before = g.ballStage; g.step(1 / 60);
    if (g.lastHitter === seat && bx === null) { bx = 'hit'; }
    if (bx === 'hit' && g.ballStage === 'live') { bx = g.ball.p[0] * sg; break; }
    if (bx === 'hit' && g.phase !== 'rally') break;
  }
  console.log('seat', seat, 'lat', lat, 'lands player-right x', typeof bx === 'number' ? bx.toFixed(1) : bx);
}
