#!/bin/bash

echo ‘Starting TM_4_0_Design’ 

cd TM_4_0_Design
#npm install
npm start &


echo ‘Starting TM_4_0_GraphDB’ 

cd ..
#npm install
cd TM_4_0_GraphDB
npm run dev &

cd ..
#npm install

wait
