function is_ipv4()
{
    local OCTETS=
    local OLD_IFS=${IFS}

    if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        IFS='.'
        OCTETS=(${1})
        IFS=$OLD_IFS
        if [   ${OCTETS[0]} -le 255 \
        	-a ${OCTETS[1]} -le 255 \
            -a ${OCTETS[2]} -le 255 \
            -a ${OCTETS[3]} -le 255 ]; then
        	return 0
    	fi
    fi
    return 1
}

# This will recognize any address that matches forms 1 and 2 in RFC
# 4291, Section 2.2.
# TODO: Implement form 3: x:x:x:x:x:x:d.d.d.d
function is_ipv6()
{
    if [ -z "$1" ]; then
        return 1
    fi

	local OLD_IFS=${IFS}
	IFS=:
	local HEXETS=(${1})
	IFS=$OLD_IFS
    local LEN=${#HEXETS[*]}

    local REJECT_BLANK=

    if [ "${LEN}" -gt 8 ]; then
        # With more than 8 fields, the input is too long
        return 1
    elif [ "${LEN}" -eq 8 ]; then
        # With 8 fields, there's no room for ::
        REJECT_BLANK=reject
    fi

    local I=0
    local FIRST_BLANK=
    for I in `seq 0 $[${LEN}-1]`; do
        if [ -z "${HEXETS[$I]}" ]; then
            if [ "${I}" -eq 0 ]; then
                FIRST_BLANK=blank
            elif [ -n "${REJECT_BLANK}" ]; then
                # Fail if more than one ::
                return 1
            else
                REJECT_BLANK=reject
            fi
        elif [ "${I}" -eq 1 -a -n "${FIRST_BLANK}" ]; then
            # Fail on initial colon that's not part of ::
            return 1
        elif ! [[ "${HEXETS[$I]}" =~ ^[0-9a-zA-Z]{1,4}$ ]]; then
            # Fail if not a 1- to 4-digit hex number
            return 1
        fi
    done

    if [ "${1:(-1)}" = ":" -a "${1:(-2)}" != "::" ]; then
        # Fail if value ends with stray colon.
        return 1
    fi

    if [ "${LEN}" -lt 8 -a -z "${REJECT_BLANK}" ]; then
        # Fail if there are fewer than 8 values, and no ::
        return 1
    fi

    # If you made it this far, you're an IPv6 address.
	return 0
}
