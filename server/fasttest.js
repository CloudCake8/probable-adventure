import { Game, planRally } from './sim.js';
const res = {};
for (const [name, power, T, depth] of [['fast', 1, undefined, 13], ['smash', 1, 0.27, 14], ['mid', 0.6, undefined, 10]]) {
  let n = 0, h = 0; const fails = [];
  for (const tx of [-8, -4, 0, 4, 8]) for (const sw of [1, -1]) {
    const g = new Game(); g.seats[0].kind = 'human'; g.seats[0].name = 'T'; g.startMatch({ skill: 0.6 });
    g.phase = 'rally'; g.ballStage = 'oppBounce'; g.lastHitter = 1; g.server = 1;
    g.ball.p = [0, 6, -15]; g.ball.v = [0, 0, 0]; g.ball.w = [0, 0, 0];
    planRally(g.ball, tx, depth, power, 0, -1, T);
    let got = false, tb = null, minY = 99;
    for (let f = 0; f < 60 * 4 && g.phase === 'rally'; f++) {
      const s = g.seats[0]; s.tilt = { y: [0, 1, 0.15], z: [0, -0.15, 1] }; s.tiltT = g.t;
      if (g.ballStage === 'live' && tb === null) tb = g.t;
      if (g.ballStage === 'live' && g.ball.p[2] > -1 && g.t - s.swingT > 0.3) g.registerSwing(0, { power: 0.7, side: sw, spin: 0, aim: 0, lat: -sw });
      g.step(1 / 60);
      if (g.lastHitter === 0) { got = true; break; }
    }
    n++; if (got) h++; else fails.push(`tx${tx}/s${sw} ${g.message || ''} ${g.ball.p.map(v=>v.toFixed(0))}`);
  }
  console.log(name, h + '/' + n, fails.slice(0, 4).join(' | '));
}
