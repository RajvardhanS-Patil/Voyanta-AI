# Architecture Diagrams — Voyanta AI

This document contains visual Mermaid.js representations of the core technical workflows inside Voyanta AI.

## 1. Overall System Architecture
Voyanta AI uses a Clean Architecture combined with a highly modular Feature-First layout.

```mermaid
graph TD
    UI[Presentation Layer: Widgets & Riverpod Controllers] --> Domain[Domain Layer: Use Cases & Entities]
    Domain --> Data[Data Layer: Repository Implementations]
    
    Data --> Local[Isar Local NoSQL Database]
    Data --> Sync[Offline Sync Queue]
    
    Sync -.-> Network{Network Connectivity}
    Network -- Online --> Supabase[(Supabase PostgreSQL)]
    Network -- Online --> Gemini[Google Gemini API]
    Network -- Online --> Mapbox[Mapbox Vector API]
    Network -- Offline --> Local
```

## 2. The Offline Sync Engine
The most complex part of Voyanta AI is ensuring data durability when traveling without cellular networks.

```mermaid
sequenceDiagram
    participant UI as User Interface
    participant Controller as Riverpod Controller
    participant Isar as Local Isar DB
    participant Queue as Sync Queue Processor
    participant API as Supabase API

    UI->>Controller: Add Expense ($45)
    Controller->>Isar: Optimistic UI Write
    Controller->>Isar: Append to Sync Queue
    
    alt Device is Offline
        Queue--xAPI: Network Blocked
        Isar-->>UI: UI Updates Immediately
    else Device is Online
        Queue->>API: Process FIFO Queue
        API-->>Queue: Acknowledge Write
        Queue->>Isar: Remove from Sync Queue
    end
```

## 3. The Live Journey Engine
The journey engine tracks GPS coordinates and geofences to orchestrate the travel timeline.

```mermaid
stateDiagram-v2
    [*] --> Idle: Awaiting Start
    Idle --> Navigating: Start Journey
    
    state Navigating {
        [*] --> TrackingGPS
        TrackingGPS --> GeofenceArrival: Within 100m of Activity
        GeofenceArrival --> ActivityActive
        ActivityActive --> TrackingGPS: Move to Next Activity
    }
    
    Navigating --> Idle: End Journey
```

## 4. AI Orchestration Pipeline
The AI Companion seamlessly feeds local context (location, budget) to Gemini to generate proactive recommendations.

```mermaid
graph LR
    User[User Input] --> Controller
    Loc[Live Location] --> Controller
    Budget[Expense DB] --> Controller
    
    Controller --> Prompt[Prompt Builder Engine]
    Prompt --> Gemini[Gemini 1.5 Flash]
    
    Gemini --> JSON[JSON Validator]
    JSON --> UI[Chat UI]
```
