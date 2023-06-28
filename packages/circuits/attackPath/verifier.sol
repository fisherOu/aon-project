// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 9379935186559649444344888825969962896808447923147577842953009631483178848827;
    uint256 constant alphay  = 10105700713478322153265819304394212997233786026981784373385953009396168201881;
    uint256 constant betax1  = 2170515858403692420101238417277028306494891917043097078695995851002375233334;
    uint256 constant betax2  = 5772244327702213711297869434073266375739850918029999312386893896326662359009;
    uint256 constant betay1  = 2905347203829954854497342500301966311961574001177826519003011389148533584785;
    uint256 constant betay2  = 4037278387274693506580487762750284500269022560990847271713715165852125481586;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 15904064729109624787963360595670475048951706692522143075738959188068027509522;
    uint256 constant deltax2 = 12085801290114216488143536115599262825295357165423105702663476798107461624053;
    uint256 constant deltay1 = 2324910278264061500620991883627122755515896977292224381380694985084758791287;
    uint256 constant deltay2 = 17439900043505917697553134923669321936879685082307231438011836247082006777442;

    
    uint256 constant IC0x = 21359050628025448243796866366048485750246367411461303247739158103253346740782;
    uint256 constant IC0y = 21039714418141090220326434952543077716119033455272362655211343685099484141472;
    
    uint256 constant IC1x = 8032324236466851613039975132532036308721463760427408764093345047189108976618;
    uint256 constant IC1y = 10763163605866671463816420216650585913395785748054315071406684923005190756507;
    
    uint256 constant IC2x = 1902722594589233872089364886593957315094494386360790510441287621587051923403;
    uint256 constant IC2y = 15761081537711426633584872010381516104069199757375335286970244705200683492869;
    
    uint256 constant IC3x = 18345606218542845274117428001906430223798190687907558952920239623933545242081;
    uint256 constant IC3y = 13744846994280880529992330692123617273027797387848369486053524201653379083897;
    
    uint256 constant IC4x = 20832419558709562905863571957362887437514435549114976140210959329696169825444;
    uint256 constant IC4y = 5338596108251216892644724564677750764357804460494774999875063102580620939077;
    
    uint256 constant IC5x = 10738005142856154335084648887057838542470546767589850679064318010268422141219;
    uint256 constant IC5y = 759322860820904157535119752094479481786856130448809012525341137382152517450;
    
    uint256 constant IC6x = 19015383134995189603051997021934407050974907712487453720776920117698549335861;
    uint256 constant IC6y = 3305907519270549900804666294637508786912072165437465650467507673246808931057;
    
    uint256 constant IC7x = 9386721075813789810262065250627795597779879448304408511453343691858622355606;
    uint256 constant IC7y = 12440372430099111834289573529278073852781293061764606815225057264246127106391;
    
    uint256 constant IC8x = 1041158365369214155724486568132159924544410365338805462835825847368335337855;
    uint256 constant IC8y = 15090171697313207918237199111264084676189252194855849334889606928343946120332;
    
    uint256 constant IC9x = 5642306122045582931667626495332435619874110890313499579054832173753384392943;
    uint256 constant IC9y = 5390577396496381989813998739912334659117095574168412295834898668033116016558;
    
    uint256 constant IC10x = 20199033251570422964073451603487847810237849068640301460933502367323526989853;
    uint256 constant IC10y = 1761699781737537030465120440914032222178311946642330160349279982048866279852;
    
    uint256 constant IC11x = 7891300164584567663619522409349741461946384843826668321595671444899594454142;
    uint256 constant IC11y = 9318595076604378905764418489345023829607662684966274580778299771858887680211;
    
    uint256 constant IC12x = 12319771542064788514523220399457957724987363553123041476293691073946644844739;
    uint256 constant IC12y = 6929285750620105700796072346142503680674959263461397106526834133744298700210;
    
    uint256 constant IC13x = 8644636577025729579533616197132036645999811613143276201904183775926953448877;
    uint256 constant IC13y = 7547646877247186918944989725151412162762312719804949564873214187628496472595;
    
    uint256 constant IC14x = 13853205626631642391572661414707369740742348277222855527278567683227743478863;
    uint256 constant IC14y = 18713144535882687428244518533715759143112688867276307614554954471622223046596;
    
    uint256 constant IC15x = 2782051207784501808180879606302485719853604240615914085724806680710253636494;
    uint256 constant IC15y = 1030871694914066325976657275947561011347674252317829348235866558136167112804;
    
    uint256 constant IC16x = 7885581815473232541313818867441723916501957673330463296848572207277755472588;
    uint256 constant IC16y = 13637395198563950326977531915853524471777274903049147870749208182608470980821;
    
    uint256 constant IC17x = 18058871972800117453651622812892925532589177235338288850334435584746787428736;
    uint256 constant IC17y = 18620508502276465296296642639019685195490341892390482035801256934199344881949;
    
    uint256 constant IC18x = 1742471671321062444460504392407735703701664431539870965351356346298524898168;
    uint256 constant IC18y = 6365328051760314854692353683783025724540165892041049589522879565840481472249;
    
    uint256 constant IC19x = 12715034545914320119697107541302568279461946787241774234089408659040990355364;
    uint256 constant IC19y = 4559305068217886622193421104462739382396855300108422547545827905775786930763;
    
    uint256 constant IC20x = 3492512699308675946984340970879575063673081368606577015554257694189726281077;
    uint256 constant IC20y = 16483645062431151325690710240943633093659692576394726217967969712013781648032;
    
    uint256 constant IC21x = 6639161460767923825547488247855012711761067032272387438081814198709446434141;
    uint256 constant IC21y = 1741562328750327398146921459975442931916050140977703400126152029924688481722;
    
    uint256 constant IC22x = 15447886210947535334717379171926530480276788697465366503976964999930511670479;
    uint256 constant IC22y = 10060245822402524012082085829764883106808428004734276331806619787078115863770;
    
    uint256 constant IC23x = 6877356976773498613636918913235742135138566011161241703957141059129016028761;
    uint256 constant IC23y = 15029499817794636558144085428199421906997156327610549774316216692589363237105;
    
    uint256 constant IC24x = 1597346966075803079096207790567466149101785858869732582397217278532264572504;
    uint256 constant IC24y = 8682861166852503674481741184743547826760508319661464012700448576072979302268;
    
    uint256 constant IC25x = 18908146627210992913028021493903847198468671298833810084709618634164827847400;
    uint256 constant IC25y = 6163304038393312698496117606011178299795479045670549811112729128573633690181;
    
    uint256 constant IC26x = 13628958991066287718820804855262354307645009150388521437443046876395465126859;
    uint256 constant IC26y = 6644863853964149821330321201008036727467870467088249014488693444473601994935;
    
    uint256 constant IC27x = 13887275783877079283833645936665064090944426316911754550495035183895944381921;
    uint256 constant IC27y = 8215664785954884222001874640442791039977700698496251752123759208587642263078;
    
    uint256 constant IC28x = 5131197643614888324156459012823335572560101531441076770275513279413982402788;
    uint256 constant IC28y = 21069294038419399695276471225508329958590653877951297594198150100978758054410;
    
    uint256 constant IC29x = 7695761293850035579088242410075180081360593723088441216285743994792939052353;
    uint256 constant IC29y = 9353471404468422041493174059236862264968647588002650544712834663415685293406;
    
    uint256 constant IC30x = 4967958895015382994324650633178538092823839901021376069903684318732458646692;
    uint256 constant IC30y = 5422904252964815300842429892773050009322998846744977512937500847776929682348;
    
    uint256 constant IC31x = 21082026124273308085040139148329775986304112260253719237606352358067314071083;
    uint256 constant IC31y = 20605272083150055347778861657171098296838799148519032935414611797458961963257;
    
    uint256 constant IC32x = 3181260291330103706139168370707368946974165309259730006216392187354278088594;
    uint256 constant IC32y = 17421142084966030755397415193798323731691754835588305633198990901510413046032;
    
    uint256 constant IC33x = 11435847349058881915956349871355841800044188615431360373099349184700360195280;
    uint256 constant IC33y = 12866094611190910001929247606082385645284611962179444300302509786306138970671;
    
    uint256 constant IC34x = 3885589239358859367989502984178892801115067584911756445147477313608097621694;
    uint256 constant IC34y = 790279720456429049122539731370753360277517134178420613782073080880755111472;
    
    uint256 constant IC35x = 1402664744167497611856398973374077304637506561504697066457461737610043314250;
    uint256 constant IC35y = 19998872625083764509530957628968789905401210379388816076773323476813586431277;
    
    uint256 constant IC36x = 18683906801689922866392938180413923224192978411772139813573113830217679186612;
    uint256 constant IC36y = 986558076101587214769186062845171365141799493233371820665428834008481177027;
    
    uint256 constant IC37x = 2202748980849702563844664641745562409155735937546689520030334858937592934510;
    uint256 constant IC37y = 17822590105564858797750000743666091302491759222294677481656983385371857200057;
    
    uint256 constant IC38x = 17780899501233534848422940062500177035914528859877942215551854574239483155892;
    uint256 constant IC38y = 19176065021320694400925370204684287341645328018225396771887281580937600593968;
    
    uint256 constant IC39x = 18623507429446214907835831100766742134624044139330758356084972186022740124673;
    uint256 constant IC39y = 14146584103522818799292800976346790611201383471346413535409223485972842298186;
    
    uint256 constant IC40x = 13644591128883989142529358864929621019566570238957486409404397730352689389590;
    uint256 constant IC40y = 5811757810233502627296156894380868080638369777566687728258109597340145173056;
    
    uint256 constant IC41x = 2142975447257299414529263716150509646950205504650199351141678108622771626914;
    uint256 constant IC41y = 8392568879201697736815937932029982882686972939691942105391678776230919326620;
    
    uint256 constant IC42x = 5815714714264322148927683303140643869658003947085918244926293312498759729723;
    uint256 constant IC42y = 1079857621339893669486282455564463066245627370330171202334722317078505041663;
    
    uint256 constant IC43x = 14558055058957425850296191115893534569369841875721202923923731275407174834123;
    uint256 constant IC43y = 18105538212683035084668597398824412525847303169144399088399365244802210947816;
    
    uint256 constant IC44x = 422030703748007849676168820830961314010888286024800962329625085045559672316;
    uint256 constant IC44y = 1408022580586120895186322258609871409043484983859659586089152906765075457402;
    
    uint256 constant IC45x = 7355717047024821013565581527355561605792288041550886689553499341437377293882;
    uint256 constant IC45y = 8927928775180079766757606049628555990445644853692961590617533689292771483652;
    
    uint256 constant IC46x = 14794401804160370800651110422067006338449178476996737121863329007329502037928;
    uint256 constant IC46y = 569567843405578414800974732184443460697613892883346182059373118727300873380;
    
    uint256 constant IC47x = 1470980799763317916500337252225740232857147902687293756795412900155409922400;
    uint256 constant IC47y = 10252361819061667345925702669581457908712049789237374978754615709063560440743;
    
    uint256 constant IC48x = 12065734507505418661065484473998548534098146189952462105727448453106838896508;
    uint256 constant IC48y = 670487463814168116640682966917838030422582455334640472044681280594000466863;
    
    uint256 constant IC49x = 10015187477377831274720113669468193973457408301057562306903723317737973787363;
    uint256 constant IC49y = 10500908006233078256993644729350584949839208642810563184055821188700943947346;
    
    uint256 constant IC50x = 9180924880099752908017344898271262068783406656321929412028189052909917930892;
    uint256 constant IC50y = 21737897659272161087173577298453783185499033523601519884771496575282519448591;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[50] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
