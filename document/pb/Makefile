KNN_DIR:=../..
CORE_DIR:=$(KNN_DIR)

include $(KNN_DIR)/core.mk

include $(KNN_DIR)/submodules/TEX/document/document.mk

pdf-clean: 
	rm -f $(DOC_TYPE).pdf

clean: texclean
