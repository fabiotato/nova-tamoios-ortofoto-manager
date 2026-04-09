;;; ============================================================
;;; OrtoFoto Manager — Auto-correcao de paths de Ortofotos
;;; ============================================================

(defun c:FIX_ORTOFOTOS (/ newpath doc imgDict imgObj oldPath fileName newFullPath fixedCount)

  (setq newpath "E:\\PROJETOS_NOVA TAMOIOS E PISF\\Mapa de Pendencias - Panorama da Obra - Kyioshi FINAL - Standard\\Ortofotos Nova Tamoios")
  (setq fixedCount 0)
  (setq doc (vla-get-ActiveDocument (vlax-get-acad-object)))

  (princ (strcat "\nBuscando ortofotos em: " newpath))

  (if (not (vl-catch-all-error-p
             (vl-catch-all-apply
               'vla-item
               (list (vla-get-Dictionaries doc) "ACAD_IMAGE_DICT"))))
    (progn
      (setq imgDict (vla-item (vla-get-Dictionaries doc) "ACAD_IMAGE_DICT"))

      (vlax-for imgObj imgDict
        (if (= (vla-get-ObjectName imgObj) "AcDbRasterImageDef")
          (progn
            (setq oldPath (vlax-get imgObj "ActiveFileName"))
            (setq fileName (vl-filename-base oldPath))
            (setq newFullPath
              (strcat newpath "\\" fileName
                (if (vl-filename-extension oldPath)
                  (vl-filename-extension oldPath)
                  ".png")))

            (if (findfile newFullPath)
              (progn
                (vlax-put imgObj "ActiveFileName" newFullPath)
                (setq fixedCount (1+ fixedCount))
                (princ (strcat "\n[OK] " fileName " -> " newFullPath))
              )
              (princ (strcat "\n[NAO ENCONTRADO] " fileName
                             " esperado em: " newFullPath))
            )
          )
        )
      )

      (vla-regen doc acAllViewports)
      (vla-save doc)
      (princ (strcat "\n\n=== Total corrigido: " (itoa fixedCount) " ortofotos ===\n"))
    )
    (princ "\nERRO: Nenhum dicionario ACAD_IMAGE_DICT encontrado neste DWG.")
  )
  (princ)
)

(princ "\nComando FIX_ORTOFOTOS carregado. Digite FIX_ORTOFOTOS para executar.")
(princ)