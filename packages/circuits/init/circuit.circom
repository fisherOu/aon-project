pragma circom 2.0.0;

/*
    Prove: I know (x,y,seed) such that:
    - x <= r && y <= r
    - MiMCSponge(x,y,seed) = pub
*/

include "../../client/node_modules/circomlib/circuits/mimcsponge.circom";
include "../../client/node_modules/circomlib/circuits/comparators.circom";
include "../range_proof/circuit.circom";
// include "../perlin/compiled.circom";

template Main() {
    signal input x;
    signal input y;
    signal input seed;
    signal input r;

    signal output pub;

    /* check abs(x), abs(y), abs(r) < 2^32 */
    component rp = MultiRangeProof(2, 40, 2 ** 32);
    rp.in[0] <== x;
    rp.in[1] <== y;

    /* check x <= r && y <= r */
    component comp = LessThan(32);
    comp.in[0] <== x;
    comp.in[1] <== r;
    comp.out === 1;
    component comp1 = LessThan(32);
    comp1.in[0] <== y;
    comp1.in[1] <== r;
    comp1.out === 1;

    /* check MiMCSponge(x,y,seed) = pub */
    /*
        220 = 2 * ceil(log_5 p), as specified by mimc paper, where
        p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
    */
    component mimc = MiMCSponge(3, 220, 1);

    mimc.ins[0] <== x;
    mimc.ins[1] <== y;
    mimc.ins[2] <== seed;
    mimc.k <== 0;

    pub <== mimc.outs[0];
}

component main { public [seed, r] } = Main();