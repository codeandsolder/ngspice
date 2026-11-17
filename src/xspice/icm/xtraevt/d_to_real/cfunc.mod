
#include <float.h>
#include <math.h>

/* Avoid overflowing the intermediate sum for finite endpoint values.
 * Opposite signs cannot overflow on addition, while equal-sign large
 * operands must be halved first. For small numbers add before halving:
 * halving subnormals first would lose representable bits.
 */
static double d_to_real_midpoint(double zero, double one)
{
    if (signbit(zero) != signbit(one) ||
        (fabs(zero) <= DBL_MAX / 2.0 && fabs(one) <= DBL_MAX / 2.0))
        return (zero + one) / 2.0;

    return zero / 2.0 + one / 2.0;
}

void ucm_d_to_real (ARGS)
{

    Digital_State_t     in;

    double              *out;
    double              delay;
    double              zero;
    double              one;
    double              ena;


    in = INPUT_STATE(in);
    if(PORT_NULL(enable))
        ena = 1.0;
    else if(INPUT_STATE(enable) == ONE)
        ena = 1.0;
    else
        ena = 0.0;
    out = (double *) OUTPUT(out);

    zero  = PARAM(zero);
    one   = PARAM(one);
    delay = PARAM(delay);


    /* Select the disabled output before calculating the midpoint:
     * NaN/Inf * 0.0 is NaN, not the requested disabled value zero.
     */
    if(ena == 0.0)
        *out = 0.0;
    else if(in == ZERO)
        *out = zero;
    else if(in == UNKNOWN)
        *out = d_to_real_midpoint(zero, one);
    else
        *out = one;

    if(TIME > 0.0)
        OUTPUT_DELAY(out) = delay;

}




