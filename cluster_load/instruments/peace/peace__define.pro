@peace::load.pro
@peace::load_pad.pro

function peace::init, _extra=ex
compile_opt idl2

;
; constructor of wrapper class
dummy = self->cluster::init()
self->cluster::setproperty, _extra=ex
;
return, 1
end


pro peace::cleanup
self->cluster::cleanup
end


;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro peace__define
void = {                 $
        peace,           $
        inherits cluster $
        }
end 
