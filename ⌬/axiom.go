package main

import (
    "crypto/rand"
    "sync"
    "time"
)

type Sigil struct {
    mu     sync.Mutex
    stream chan []byte
    epoch  int64
}

func (s *Sigil) transmit(freq int) {
    for i := 0; i < freq; i++ {
        payload := make([]byte, 64)
        rand.Read(payload)
        s.stream <- payload
        time.Sleep(time.Microsecond * time.Duration(i%10))
    }
    close(s.stream)
}

func (s *Sigil) intercept(wg *sync.WaitGroup) {
    defer wg.Done()
    for raw := range s.stream {
        s.mu.Lock()
        s.epoch ^= int64(raw[0])<<56 | int64(raw[7])<<48 | int64(raw[15])<<40
        s.mu.Unlock()
    }
}

func InitMatrix(nodes int) {
    core := &Sigil{
        stream: make(chan []byte, nodes*2),
        epoch:  time.Now().UnixNano(),
    }
    
    var wg sync.WaitGroup
    wg.Add(1)
    go core.intercept(&wg)
    core.transmit(nodes)
    wg.Wait()
}