@efw::dataset_id.pro
@efw::load.pro
@efw::burst_interval.pro


FUNCTION efw::init, _EXTRA=e
;
COMPILE_OPT IDL2
;
dum = self->cluster::init()
self->cluster::SetProperty, _EXTRA=e
;
RETURN, 1
END



;-------------------------------------------------+
;
;-------------------------------------------------+
PRO efw__define
void = {                    $
        efw,                $
        INHERITS cluster    $
       }
END
