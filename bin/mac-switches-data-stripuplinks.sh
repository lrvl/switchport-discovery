#!/bin/bash
#
# The software known as Network Discovery is distributed under the following terms:
# Copyright 2016-2016 Leroy van Logchem.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#
#   Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#   Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#
#   THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
#   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#   IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
#   OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#   OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#   OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Authors       Paul Vlenterie    ( paul.vlenterie@deltares.nl                             )
# Create date   Jul 2016
# Description   WARNING: Static variant, removes known uplinks ( Not Dynamic! )
#

source "include.sh"

OUTPUT="$ROOT/var/switches/"
sed -i  '/Gigabit/ d' "$OUTPUT"/3com-fsw04wgc
sed -i  '/Gigabit/ d' "$OUTPUT"/3com-fsw05wgc
sed -i  '/Gigabit/ d' "$OUTPUT"/3com-fsw05wgn
#
sed -i -e '/Et1/ d' -e '/Et2/ d' -e '/Et3/ d' -e '/Et5/ d' -e '/Et6/ d' -e '/Et8/ d' -e '/Et9/ d' -e '/Et13/ d' -e '/Et14/ d' -e '/Et17/ d' -e '/Et51/ d' -e '/Po110/ d' -e '/Po121/ d' "$OUTPUT"/arista-gsw10wgc
sed -i '/Po111/ d' "$OUTPUT"/arista-gsw11wgc
sed -i '/Po112/ d' "$OUTPUT"/arista-gsw13wgn
sed -i -e '/Et22/ d' -e '/Et23/ d' -e '/Et24/ d' "$OUTPUT"/arista-tsw01sto
sed -i -e '/Et41/ d' -e '/Et42/ d'  -e '/Et43/ d' -e '/Et44/ d' -e '/Et45/ d' -e '/Et46/ d' -e '/Et47/ d' -e '/Et48/ d'   -e '/Po100/ d' "$OUTPUT"/arista-tsw01wgc
sed -i -e '/Et41/ d' -e '/Et42/ d'  -e '/Et43/ d' -e '/Et44/ d' -e '/Et45/ d' -e '/Et46/ d' -e '/Po100/ d' "$OUTPUT"/arista-tsw01wgn
sed -i -e '/Po200/ d' -e '/Po202/ d' -e '/Po203/ d' -e '/Po204/ d' -e '/Po210/ d' -e '/Po211/ d' -e '/Po212/ d' -e '/Po213/ d' -e '/Po214/ d' -e '/Po207/ d' -e '/Po208/ d' -e '/Po206/ d' -e '/Po213/ d' -e '/Po205/ d' "$OUTPUT"/arista-tsw02hk8
sed -i -e '/Et23/ d' -e '/Et24/ d' "$OUTPUT"/arista-tsw02sto
sed -i -e '/Po200/ d' -e '/Po202/ d' -e '/Po203/ d' -e '/Po204/ d' -e '/Po210/ d' -e '/Po211/ d' -e '/Po212/ d' -e '/Po213/ d' -e '/Po214/ d' -e '/Po207/ d' -e '/Po208/ d' -e '/Po206/ d' -e '/Po213/ d' -e '/Po205/ d' "$OUTPUT"/arista-tsw02wgn
sed -i -e '/Et11/ d' -e '/Et12/ d' -e '/Po100/ d' "$OUTPUT"/arista-tsw04hk8
sed -i -e '/Et23/ d' -e '/Po100/ d' "$OUTPUT"/arista-tsw04wgn
sed -i '/Et49/ d' "$OUTPUT"/arista-tsw07wgn
sed -i '/Et49/ d' "$OUTPUT"/arista-tsw08wgn
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw1hr08
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw1hr09
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw1hr10
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw1hr11
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw1hr12
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw2hr08
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw2hr09
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw2hr10
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw2hr11
sed -i -e '/Et51/ d' -e '/Et52/ d'  "$OUTPUT"/arista-tsw2hr12
#
sed -i -e '/Po1/ d' -e '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw03hk8
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr08
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr09
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr10
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr11
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr12
sed -i '/Gi1\/0\/10/ d' "$OUTPUT"/cisco-gsw1hr13
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw1hr13
sed -i '/Gi1\/0\/[1-9]/ d' "$OUTPUT"/cisco-gsw1hr13
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw2hr08
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw2hr09
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw2hr10
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw2hr11
sed -i '/Gi1\/0\/48/ d' "$OUTPUT"/cisco-gsw2hr12
#
sed -i '/Gi0\/16/ d' "$OUTPUT"/dlink1-gsw15wgn
sed -i '/ 25/ d' "$OUTPUT"/dlink-fsw04wgn
sed -i '/ 25/ d' "$OUTPUT"/dlink-gsw02sto
sed -i '/ 28/ d' "$OUTPUT"/dlink-gsw03wgn
sed -i '/ 25/ d' "$OUTPUT"/dlink-gsw12wgc
sed -i '/ 25/ d' "$OUTPUT"/dlink-gsw12wgn
sed -i '/ 28/ d' "$OUTPUT"/dlink-gsw13wgc
sed -i '/ 25/ d' "$OUTPUT"/dlink-gsw14wgn
sed -i '/ 52/ d' "$OUTPUT"/dlink-gsw16wgn
sed -i '/ 50/ d' "$OUTPUT"/dlinkt-fsw03wgn
sed -i '/T1/ d' "$OUTPUT"/dlink-xsw02wgc
sed -i '/1:19/ d' "$OUTPUT"/dlink-xsw03wgc
sed -i -e '/T1/ d' -e '/1:50/ d' -e '/3:48/ d' "$OUTPUT"/dlink-xsw03wgn
sed -i -e '/T1/ d' -e '/1:11/ d' "$OUTPUT"/dlink-xsw04wgc
sed -i '/1:24/ d' "$OUTPUT"/dlink-xsw06wgc
