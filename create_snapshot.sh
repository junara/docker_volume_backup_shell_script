while getopts b:t:i OPTION; do
  case $OPTION in
  b) bck_volume=$OPTARG ;;
  t) tgt_volume=$OPTARG ;;
  i) bck_docker_image=$OPTARG ;;
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
echo '===START RESET BACKUP VOLUME===' &&
  docker volume rm -f $bck_volume &&
  docker volume create $bck_volume &&
  echo '===END RESET BACKUP VOLUME===' &&
  echo '===START BACKUP===' &&
  docker run --rm -v $bck_volume:/$bck_directory -v $tgt_volume:/$tgt_directory $work_docker_image bash -c "cd / && tar cvf $bck_directory/$bck_tar_file $tgt_directory" &&
  echo "===Docker volume [$tgt_volume] is copied to [$bck_tar_file] file in Docker volume [$bck_volume] ===" &&
  echo '===END BACKUP===' &&
  echo '===FINISH==='
