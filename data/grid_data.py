from grid_data import extract_semo

def run(event, context):
  extract_semo.main(run_time=event.run_time, base_path=event.s3_path)