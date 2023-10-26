
@aux::dataset_id.pro
@aux::load.pro


function aux::init, _extra=ex
compile_opt idl2

;
; constructor of wrapper class
dummy = self->cluster::init()
self->cluster::setproperty, _extra=ex
;
return, 1
end




;----------------------------------------------------------+
; 
;----------------------------------------------------------+
pro aux__define
void = {                 $
        aux,             $
        inherits cluster $
        }
end   
