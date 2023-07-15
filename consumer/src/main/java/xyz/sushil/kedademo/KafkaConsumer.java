package xyz.sushil.kedademo;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class KafkaConsumer {

  @KafkaListener(topics = "${kafka.topic}", groupId = "${kafka.consumer-group-id}")
  public void handle(String message) throws InterruptedException {
    int delay = Integer.parseInt(message) * 100;
    System.out.println("Sleeping for : " + delay + " ms.");
    Thread.sleep(delay);
  }

}
