import { Game, planRally } from './sim.js';
for (const [name, power, T, depth] of [['fast', 1, undefined, 13], ['smash', 1, 0.27, 14], ['mid', 0.6, undefined, 10]]) {
  const out = [];
  for (const off of [-0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3]) {   // swing start relative to bounce on our half
    let n = 0, h = 0, ys = [];
    for (const tx of [-8, 0, 8]) for (const sw of [1, -1]) {
      const g = new Game(); g.seats[0].kind = 'human'; g.seats[0].name = 'T'; g.startMatch({ skill: 0.6 });
      g.phase = 'rally'; g.ballStage = 'oppBounce'; g.lastHitter = 1; g.server = 1;
      g.ball.p = [0, 6, -15]; g.ball.v = [0, 0, 0]; g.ball.w = [0, 0, 0];
      planRally(g.ball, tx, depth, power, 0, -1, T);
      let got = false, tb = null, sw0 = false;
      for (let f = 0; f < 60 * 4 && g.phase === 'rally'; f++) {
        const s = g.seats[0]; s.tilt = { y: [0, 1, 0.15], z: [0, -0.15, 1] }; s.tiltT = g.t;
        if (g.ballStage === 'live' && tb === null) tb = g.t;
        const ref = tb === null ? null : tb + off;
        if (!sw0 && ((off < 0 && g.ballStage === 'oppBounce' && g.ball.p[2] > -9 + off * 60) || (ref !== null && g.t >= ref))) { g.registerSwing(0, { power: 0.7, side: sw, spin: 0, aim: 0, lat: -sw }); sw0 = true; }
        g.step(1 / 60);
        if (g.ballStage === 'live' && g.ball.p[2] > 16 && g.ball.p[2] < 18) ys.push(g.ball.p[1].toFixed(1));
        if (g.lastHitter === 0) { got = true; break; }
      }
      n++; if (got) h++;
    }
    out.push(`${off}:${h}/${n}`);
  }
  console.log(name, out.join(' '));
}
