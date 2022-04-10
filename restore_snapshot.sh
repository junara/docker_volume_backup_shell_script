while getopts b:t:i OPTION; do
  case $OPTION in
  b) bck_volume=$OPTARG ;;
  t) tgt_volume=$OPTARG ;;
  i) work_docker_image=$OPTARG ;;
  esac
done

if [ -z "$bck_volume" ]; then
  echo '-b must be needed. Please write back up Docker volume name.'
  exit 1
fi

if [ -z "$tgt_volume" ]; then
  echo '-t must be needed. Please write back up target Docker volume name.'
  exit 1
fi

if [ -z "$work_docker_image" ]; then
  work_docker_image="ubuntu:latest"
fi

bck_directory="bck"
tgt_directory="tgt"
bck_tar_file="bck.tar"

echo '===START==='
echo '===START RESET TARGET VOLUME===' &&
  echo "===Delete all data in [$tgt_volume] Docker volume." &&
  docker run --rm -v $tgt_volume:/$tgt_directory $work_docker_image bash -c "rm -rf $tgt_directory/*" &&
  echo '===END RESET TARGET VOLUME===' &&
  echo '===START COPY BACKUP VOLUME TO TARGET DIRECTORY===' &&
  echo "=== Restore data from [$bck_tar_file] in [$bck_volume] Docker volume to [$tgt_volume] Docker volume." &&
  docker run --rm -v $bck_volume:/$bck_directory -v $tgt_volume:/$tgt_directory $work_docker_image bash -c "cd /$tgt_directory && tar -xvf /$bck_directory/$bck_tar_file --strip-components=1" &&
  echo '===END COPY BACKUP VOLUME TO TARGET DIRECTORY==='
echo '===FINISH==='
