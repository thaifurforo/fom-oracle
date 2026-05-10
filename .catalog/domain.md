# FOM Oracle — Domínio

## Entidades principais

```sql
CREATE TABLE game_installation (
  id TEXT PRIMARY KEY,
  install_path TEXT NOT NULL,
  game_version TEXT,
  catalog_version TEXT,
  last_scanned_at TEXT,
  status TEXT NOT NULL
);

CREATE TABLE save_source (
  id TEXT PRIMARY KEY,
  root_path TEXT NOT NULL,
  detection_mode TEXT NOT NULL,
  is_default_path INTEGER NOT NULL,
  last_scanned_at TEXT,
  status TEXT NOT NULL
);

CREATE TABLE player_save (
  id TEXT PRIMARY KEY,
  save_source_id TEXT NOT NULL,
  display_name TEXT NOT NULL,
  slot_key TEXT NOT NULL,
  file_path TEXT NOT NULL,
  last_modified_at TEXT,
  detected_game_version TEXT,
  compatibility_status TEXT NOT NULL,
  FOREIGN KEY (save_source_id) REFERENCES save_source(id)
);

CREATE TABLE save_snapshot (
  id TEXT PRIMARY KEY,
  player_save_id TEXT NOT NULL,
  captured_at TEXT NOT NULL,
  raw_fingerprint TEXT NOT NULL,
  day_number INTEGER,
  season TEXT,
  town_rank TEXT,
  mine_level INTEGER,
  gold_amount INTEGER,
  parse_status TEXT NOT NULL,
  FOREIGN KEY (player_save_id) REFERENCES player_save(id)
);

CREATE TABLE user_preference (
  id TEXT PRIMARY KEY,
  selected_save_id TEXT,
  selected_save_source_id TEXT,
  preferred_refresh_label TEXT,
  updated_at TEXT NOT NULL
);

CREATE TABLE priority_profile (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  is_system INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE priority_selection (
  id TEXT PRIMARY KEY,
  profile_id TEXT NOT NULL,
  priority_code TEXT NOT NULL,
  rank_order INTEGER NOT NULL,
  enabled INTEGER NOT NULL,
  FOREIGN KEY (profile_id) REFERENCES priority_profile(id)
);

CREATE TABLE recommendation_batch (
  id TEXT PRIMARY KEY,
  snapshot_id TEXT NOT NULL,
  profile_id TEXT NOT NULL,
  generated_at TEXT NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY (snapshot_id) REFERENCES save_snapshot(id),
  FOREIGN KEY (profile_id) REFERENCES priority_profile(id)
);

CREATE TABLE recommendation_item (
  id TEXT PRIMARY KEY,
  batch_id TEXT NOT NULL,
  rank_order INTEGER NOT NULL,
  category_code TEXT NOT NULL,
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  rationale TEXT NOT NULL,
  blocking_condition TEXT,
  source_trace TEXT,
  FOREIGN KEY (batch_id) REFERENCES recommendation_batch(id)
);

CREATE TABLE knowledge_source (
  id TEXT PRIMARY KEY,
  source_type TEXT NOT NULL,
  name TEXT NOT NULL,
  version TEXT,
  trust_level TEXT NOT NULL,
  last_loaded_at TEXT
);
```

## Agregados de domínio

### Save Aggregate
- `SaveSource`
- `PlayerSave`
- `SaveSnapshot`
- Responsabilidade: descobrir, registrar, carregar e versionar estado lido do jogo.

### Knowledge Aggregate
- `GameInstallation`
- `KnowledgeSource`
- catálogos derivados da instalação local
- Responsabilidade: extrair e versionar conhecimento estrutural do jogo.

### Planning Aggregate
- `PriorityProfile`
- `PrioritySelection`
- `RecommendationBatch`
- `RecommendationItem`
- Responsabilidade: transformar snapshot + prioridades em plano acionável.

### Preference Aggregate
- `UserPreference`
- Responsabilidade: restaurar contexto operacional entre sessões.

## Objetos de valor

- `GameVersion`
- `SaveFingerprint`
- `PriorityCode`
- `RecommendationCategory`
- `CompatibilityStatus`
- `RationaleTrace`
- `InventorySummary`
- `RelationshipProgress`
- `MineProgress`
- `AnimalBreedingProgress`

## Relacionamentos de alto nível

- Um `SaveSource` possui muitos `PlayerSave`.
- Um `PlayerSave` possui muitos `SaveSnapshot`.
- Um `PriorityProfile` possui muitas `PrioritySelection`.
- Um `SaveSnapshot` combinado a um `PriorityProfile` gera um `RecommendationBatch`.
- Um `RecommendationBatch` possui muitos `RecommendationItem`.
- Uma `GameInstallation` abastece os catálogos usados pelo motor de recomendação.

## Fontes de verdade

### Primárias
- Arquivo de save do jogador.
- Arquivos da instalação local do jogo extraíveis por engenharia reversa.

### Secundárias
- Wiki do jogo.
- Planilhas/referências comunitárias, apenas quando não houver fonte local confiável.
