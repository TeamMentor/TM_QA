#!/bin/bash

echo ‘Starting TM_4_0_Design’ 

cd TM_4_0_Design
npm start &


echo ‘Starting TM_4_0_GraphDB’ 

cd ..
cd TM_4_0_GraphDB
npm run dev &

cd ..
cd QA
npm test

wait
