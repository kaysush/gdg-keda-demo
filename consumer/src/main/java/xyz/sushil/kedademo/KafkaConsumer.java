package xyz.sushil.kedademo;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class KafkaConsumer {

  @KafkaListener(topics = "${kafka.topic}", groupId = "${kafka.consumer-group-id}")
  public void handle(String message) throws InterruptedException {
    try {
      int delay = Integer.parseInt(message) * 10;
      System.out.println("Sleeping for : " + delay + " ms.");
      Thread.sleep(delay);
    } catch(NumberFormatException ex) {
      System.out.println("Error calculating delay. Skipping this message.");
    }
  }

}
