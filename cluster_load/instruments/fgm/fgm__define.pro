
@fgm::load.pro

function fgm::init, _extra=ex
compile_opt idl2

;
; constructor of wrapper class
dummy = self->cluster::init()
self->cluster::setproperty, _extra=ex
;
return, 1
end


pro fgm::cleanup
self->cluster::cleanup
end


;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro fgm__define
void = {                 $
        fgm,             $
        inherits cluster $
        }
end
