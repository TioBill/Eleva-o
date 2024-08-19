(defun c:CE( / *error* acadObj aDoc modelSpace text-height vla-pl elevation lines-exploded line-selected text line) 
  (setq
    acadObj (vlax-get-acad-object)
    aDoc (vla-get-activedocument acadObj)
    modelSpace (vla-get-modelspace aDoc)
  )

  (vla-startundomark aDoc)

  (defun *error* (msg)
    (or 
      (wcmatch (strcase msg t) "*break,*cancel*,*exit*") 
      (alert (strcat "ERROR: " msg "**"))
    )
    (vla-endundomark aDoc)
  )
  
  (setq text-height (getreal "Digite o tamanho de texto desejado: "))

  (while t
    
    (while (not 
             (setq vla-pl 
                (ssget "_+.:E:S" '((0 . "LWPOLYLINE")))
              )
            )   
    )
  
    (setq vla-pl (vlax-ename->vla-object (ssname vla-pl 0)))
    
    (setq elevation (vla-get-elevation vla-pl))
    
    (vla-startundomark aDoc)
    (setq lines-exploded (vlax-safearray->list (vlax-variant-value (vla-explode vla-pl))))
    
    (setq line-selected (entsel "Selecione a linha com o angulo de texto desejado: "))

    (setq text (vla-addtext 
      modelSpace 
      (rtos elevation 2 0)
      (vlax-3d-point (trans (cadr line-selected)  1 0))
      text-height
    ))
    
    (vlax-put-property text 'Alignment 10)
    (vla-put-layer text (vla-get-layer (vlax-ename->vla-object (car line-selected))))
    (vla-put-color text '256)
    (vla-put-rotation text (vla-get-angle (vlax-ename->vla-object (car line-selected))))

    (foreach line lines-exploded
        (vla-delete line)
    )
  )

  (vla-endundomark aDoc)
)

(alert "Lisp carregada com sucesso! Digite \"CE\" para comecar.")