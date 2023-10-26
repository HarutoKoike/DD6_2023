

@cis::instrument.pro
@cis::load.pro
@cis::load_pad.pro
@cis::load_psd.pro

;@cis::dataset_id.pro

function cis::init, _extra=ex
compile_opt idl2
;
; constructor of wrapper class
dummy = self->cluster::init()
self->cluster::setproperty, _extra=ex
;
return, 1
end


pro cis::cleanup
self->cluster::cleanup
end


;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro cis__define
void = {                 $
        cis,             $
        inherits cluster $
        }
end 
