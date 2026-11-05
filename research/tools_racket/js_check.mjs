import {RacketPose,RemoteHeading} from './racket_pose.js';
import fs from 'fs';
const tr=JSON.parse(fs.readFileSync(new URL('./js_trace.json', import.meta.url)));
function mmul(A,B){return [0,1,2].map(i=>[0,1,2].map(j=>A[i][0]*B[0][j]+A[i][1]*B[1][j]+A[i][2]*B[2][j]));}
function sub(a,b){return a.map((x,i)=>x-b[i]);}
function cross(a,b){return [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]];}
const dot=(a,b)=>a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
function shortest(a,b){const c=cross(a,b),l=Math.hypot(...c);if(l<=1e-6)return [[1,0,0],[0,1,0],[0,0,1]];const k=c.map(x=>x/l),cs=dot(a,b),sn=l;
 const K=[[0,-k[2],k[1]],[k[2],0,-k[0]],[-k[1],k[0],0]];const R=[0,1,2].map(i=>[0,1,2].map(j=>(i==j?1:0)+sn*K[i][j]+(1-cs)*[0,1,2].reduce((s,m)=>s+K[i][m]*K[m][j],0)));return [0,1,2].map(i=>[0,1,2].map(j=>R[j][i]));}
function twist(prev,cur){const P=mmul(prev,shortest(prev[2],cur[2]));return Math.atan2(-dot(cur[1],P[0]),dot(cur[1],P[1]))*180/Math.PI;}
let worst=0;
for(const side of ['R','L']){
  const rp=new RacketPose(side==='L'); const rh=new RemoteHeading();
  let prev=[[1,0,0],[0,1,0],[0,0,1]];
  for(const f of tr[side]){
    const hs=rh.update(f.row2);
    if(f.sw) rp.startSwing(1,45);
    const o=rp.tick(f.row2,twist(prev,f.M),hs,f.active,[0,4.8,-0.24],{rows:[[1,0,0],[0,1,0],[0,0,1]],pos:[0,-6,-26]});
    prev=f.M;
    const d=Math.max(...sub(o.pivot,f.pivot).map(Math.abs), ...[0,1,2].flatMap(i=>[0,1,2].map(j=>Math.abs(o.rows[i][j]-f.rows[i][j]))));
    worst=Math.max(worst,d);
  }
}
console.log('worst diff JS vs python port',worst);
