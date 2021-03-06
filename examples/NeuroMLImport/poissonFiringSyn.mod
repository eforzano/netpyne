TITLE Mod file for component: Component(id=poissonFiringSyn type=poissonFiringSynapse)

COMMENT

    This NEURON file has been generated by org.neuroml.export (see https://github.com/NeuroML/org.neuroml.export)
         org.neuroml.export  v1.4.6
         org.neuroml.model   v1.4.6
         jLEMS               v0.9.8.6

ENDCOMMENT

NEURON {
    POINT_PROCESS poissonFiringSyn
    ELECTRODE_CURRENT i
    RANGE averageRate                       : parameter
    RANGE averageIsi                        : parameter
    
    RANGE i                                 : exposure
    RANGE syn0_tauRise                      : parameter
    RANGE syn0_tauDecay                     : parameter
    RANGE syn0_peakTime                     : parameter
    RANGE syn0_waveformFactor               : parameter
    RANGE syn0_gbase                        : parameter
    RANGE syn0_erev                         : parameter
    
    RANGE syn0_g                            : exposure
    
    RANGE syn0_i                            : exposure
    
}

UNITS {
    
    (nA) = (nanoamp)
    (uA) = (microamp)
    (mA) = (milliamp)
    (A) = (amp)
    (mV) = (millivolt)
    (mS) = (millisiemens)
    (uS) = (microsiemens)
    (molar) = (1/liter)
    (kHz) = (kilohertz)
    (mM) = (millimolar)
    (um) = (micrometer)
    (umol) = (micromole)
    (S) = (siemens)
    
}

PARAMETER {
    
    averageRate = 0.05 (kHz)
    averageIsi = 20 (ms)
    syn0_tauRise = 0.5 (ms)
    syn0_tauDecay = 10 (ms)
    syn0_peakTime = 1.5767012 (ms)
    syn0_waveformFactor = 1.2324 
    syn0_gbase = 0.0019999999 (uS)
    syn0_erev = 0 (mV)
}

ASSIGNED {
    v (mV)
    
    syn0_g (uS)                            : derived variable
    
    syn0_i (nA)                            : derived variable
    
    i (nA)                                 : derived variable
    rate_tsince (ms/ms)
    rate_syn0_A (/ms)
    rate_syn0_B (/ms)
    
}

STATE {
    tsince (ms) 
    isi (ms) 
    syn0_A  
    syn0_B  
    
}

INITIAL {
    rates()
    rates() ? To ensure correct initialisation.
    
    tsince = 0
    
    isi = -  averageIsi  * log(1 - random_float(1))
    
    net_send(0, 1) : go to NET_RECEIVE block, flag 1, for initial state
    
    syn0_A = 0
    
    syn0_B = 0
    
}

BREAKPOINT {
    
    SOLVE states METHOD cnexp
    
    
}

NET_RECEIVE(flag) {
    
    LOCAL weight
    
    
    if (flag == 1) { : Setting watch for top level OnCondition...
        WATCH (tsince  >  isi) 1000
    }
    if (flag == 1000) {
    
        tsince = 0
    
        isi = -  averageIsi  * log(1 - random_float(1))
    
        : Child: Component(id=syn0 type=expTwoSynapse)
    
        : This child is a synapse; defining weight
        weight = 1
    
        : paramMappings: {syn0={g=syn0_g, tauDecay=syn0_tauDecay, waveformFactor=syn0_waveformFactor, A=syn0_A, B=syn0_B, erev=syn0_erev, gbase=syn0_gbase, peakTime=syn0_peakTime, tauRise=syn0_tauRise, i=syn0_i}, poissonFiringSyn={isi=isi, tsince=tsince, averageRate=averageRate, averageIsi=averageIsi, i=i}}
    ?    state_discontinuity(syn0_A, syn0_A  + (weight *  syn0_waveformFactor ))
        syn0_A = syn0_A  + (weight *  syn0_waveformFactor )
    
        : paramMappings: {syn0={g=syn0_g, tauDecay=syn0_tauDecay, waveformFactor=syn0_waveformFactor, A=syn0_A, B=syn0_B, erev=syn0_erev, gbase=syn0_gbase, peakTime=syn0_peakTime, tauRise=syn0_tauRise, i=syn0_i}, poissonFiringSyn={isi=isi, tsince=tsince, averageRate=averageRate, averageIsi=averageIsi, i=i}}
    ?    state_discontinuity(syn0_B, syn0_B  + (weight *  syn0_waveformFactor ))
        syn0_B = syn0_B  + (weight *  syn0_waveformFactor )
    
        net_event(t)
        WATCH (tsince  >  isi) 1000
    
    }
    
}

DERIVATIVE states {
    rates()
    tsince' = rate_tsince 
    syn0_A' = rate_syn0_A 
    syn0_B' = rate_syn0_B 
    
}

PROCEDURE rates() {
    
    syn0_g = syn0_gbase  * ( syn0_B  -  syn0_A ) ? evaluable
    syn0_i = syn0_g  * ( syn0_erev  - v) ? evaluable
    ? DerivedVariable is based on path: synapse/i, on: Component(id=poissonFiringSyn type=poissonFiringSynapse), from synapse; Component(id=syn0 type=expTwoSynapse)
    i = syn0_i ? path based
    
    rate_tsince = 1 ? Note units of all quantities used here need to be consistent!
    
     
    rate_syn0_B = - syn0_B  /  syn0_tauDecay ? Note units of all quantities used here need to be consistent!
    rate_syn0_A = - syn0_A  /  syn0_tauRise ? Note units of all quantities used here need to be consistent!
    
     
    
}


: Returns a float between 0 and max
FUNCTION random_float(max) {
    
    random_float = scop_random()*max
    
}

