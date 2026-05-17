pub fn run() {
  tauri::Builder::default()
    .run(tauri::generate_context!())
    .expect("falha ao iniciar o shell Tauri");
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
fn main() {
  run();
}
