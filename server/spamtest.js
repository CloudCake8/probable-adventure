import { Game, planRally } from './sim.js';
let n = 0, h = 0;
for (const tx of [-8, -4, 0, 4, 8]) for (const sw of [1, -1]) for (const T of [undefined, 0.27, undefined, 0.27, undefined, 0.27]) {
  const g = new Game(); g.seats[0].kind = 'human'; g.seats[0].name = 'T'; g.startMatch({ skill: 0.6 });
  g.phase = 'rally'; g.ballStage = 'oppBounce'; g.lastHitter = 1; g.server = 1;
  g.ball.p = [0, 6, -15]; g.ball.v = [0, 0, 0]; g.ball.w = [0, 0, 0]; planRally(g.ball, tx, 13, 0.8, 0, -1, T);
  let got = false;
  const off = Math.floor(Math.random() * 60); for (let f = 0; f < 240 && g.phase === 'rally'; f++) {
    const s = g.seats[0]; s.tilt = { y: [0, 1, 0.15], z: [0, -0.15, 1] }; s.tiltT = g.t;
    if (f >= off) g.registerSwing(0, { power: 0.7, side: sw, spin: 0, aim: 0, lat: -sw });   // spam every frame
    g.step(1 / 60); if (g.lastHitter === 0) { got = true; break; }
  }
  n++; if (got) h++;
}
console.log('spam hits', h + '/' + n);
