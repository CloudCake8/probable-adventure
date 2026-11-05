import { Game } from './sim.js';
let tot = 0, hit = 0; const rows = {};
for (const [name, xs, zs] of [['wide', [-15, -12, 12, 15], [6, 12]], ['net', [-4, 0, 4], [-1, 3, 6]], ['mid', [-6, 0, 6], [10, 16]]]) {
  let n = 0, h = 0;
  for (const x of xs) for (const z of zs) for (const vz of [20, 32]) for (const side of [1, -1]) {
    const g = new Game(); g.seats[0].kind = 'human'; g.seats[0].name = 'T'; g.seats[0].hand = 1; g.startMatch({ skill: 0.6 });
    g.phase = 'rally'; g.ballStage = 'live'; g.lastHitter = 1; g.server = 1;
    g.ball.p = [x, 5, z]; g.ball.v = [(-x) * 0.1, 2, vz]; g.ball.w = [0, 0, 0];
    let got = false;
    for (let f = 0; f < 60 * 4 && g.phase === 'rally'; f++) {
      const s = g.seats[0]; s.tilt = { y: [0, 1, 0.15], z: [0, -0.15, 1] }; s.tiltT = g.t;
      const dz = g.ball.p[2];
      if (dz > z - 2 && dz < 22 && g.t - s.swingT > 0.3) g.registerSwing(0, { power: 0.7, side, spin: 0, aim: 0, lat: -side });
      g.step(1 / 60);
      if (g.lastHitter === 0) { got = true; break; }
    }
    n++; if (got) h++;
  }
  console.log(name, h + '/' + n); tot += n; hit += h;
}
console.log('total', hit + '/' + tot);
