EMSCR=em++

# ----------------------------------------
#javascript for loading JSON
RAPID_JS = src/emscripten/rapidMix.js

#the .cpp files that are used
RL_KNN=src/knnClassification.cpp src/classification.cpp
RL_SVM=src/svmClassification.cpp dependencies/libsvm/libsvm.cpp
RL_NN=src/neuralNetwork.cpp src/regression.cpp
RL_MS=src/modelSet.cpp
RL_DTW = src/dtw.cpp src/seriesClassification.cpp
RL_STREAM=src/rapidStream.cpp 
SOURCE_RAPID = $(RL_MS) $(RL_NN) $(RL_KNN) $(RL_SVM) $(RL_DTW) $(RL_STREAM)

# destination .js file
OUTPUT_RAPID=rapidLib/RapidLib.js

# ----------------------------------------
# General flags
# https://kripken.github.io/emscripten-site/docs/tools_reference/emcc.html
# -s DEMANGLE_SUPPORT=1 
CFLAGS=-O3 -s DISABLE_EXCEPTION_CATCHING=0 -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=1 -s EXPORT_NAME="'RapidLib'" --memory-init-file 0

# ----------------------------------------
# Final paths
full: $(SOURCE_RAPID)
	$(EMSCR) $(CFLAGS) -s MODULARIZE=1 --post-js $(RAPID_JS) --bind -o $(OUTPUT_RAPID) $(SOURCE_RAPID)

test: $(SOURCE_RAPID)
	$(EMSCR) $(CFLAGS) --post-js $(RAPID_JS) --bind -o $(OUTPUT_RAPID) $(SOURCE_RAPID) --profiling
	mocha

dev: full
	scp $(OUTPUT_RAPID) mzbys001@igor.doc.gold.ac.uk:/home/mzbys001/public_html/RapidMixLib.js

prod: full
	scp $(OUTPUT_RAPID) eaviuser@igor.doc.gold.ac.uk:/home/eavi/public_html/rapidmix/RapidLib.js

all: full